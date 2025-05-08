import json
import boto3
import os
import time
import random
import traceback
from datetime import datetime
from zoneinfo import ZoneInfo
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE']
table = dynamodb.Table(table_name)

def is_open(open_hour_str, close_hour_str, current_time):
    try:
        open_hour = datetime.strptime(open_hour_str, "%H:%M").time()
        close_hour = datetime.strptime(close_hour_str, "%H:%M").time()
        if open_hour <= close_hour:
            return open_hour <= current_time <= close_hour
        else:
            return current_time >= open_hour or current_time <= close_hour
    except ValueError:
        print(f"Invalid time format: {open_hour_str}, {close_hour_str}")
        return False

def get_restaurant_recommendation(
    style=None,
    vegetarian=None,
    open_now=False,
    delivery=None,
    address=None,
    last_evaluated_key=None,
    page_size=100,
    timezone=ZoneInfo("Asia/Jerusalem")
):
    try:
        all_matches = []
        now = datetime.now(timezone).time()
        scan_kwargs = {}
        if last_evaluated_key:
            scan_kwargs['ExclusiveStartKey'] = last_evaluated_key

        while True:
            scan_kwargs['Limit'] = page_size

            # Exponential backoff variables
            retries = 0
            max_retries = 5
            while retries <= max_retries:
                try:
                    response = table.scan(**scan_kwargs)
                    break  # exit retry loop on success
                except ClientError as e:
                    code = e.response['Error']['Code']
                    if code in ['ProvisionedThroughputExceededException', 'ThrottlingException']:
                        sleep_time = (2 ** retries) + random.uniform(0, 1)
                        print(f"Rate limited. Retrying in {sleep_time:.2f} seconds...")
                        time.sleep(sleep_time)
                        retries += 1
                    else:
                        raise
            else:
                return {"error": "DynamoDB request rate too high. Please try again later."}

            items = response.get('Items', [])
            last_evaluated_key = response.get('LastEvaluatedKey')

            def matches_filters(item):
                if style and item['style'].lower() != style.lower():
                    return False
                if vegetarian is not None:
                    is_veg = item['vegetarian'].lower() == 'true'
                    if vegetarian != is_veg:
                        return False
                if delivery is not None:
                    has_delivery = item['delivery'].lower() == 'true'
                    if delivery != has_delivery:
                        return False
                if address and address.lower() not in item['address'].lower():
                    return False
                if open_now and not is_open(item['openHour'], item['closeHour'], now):
                    return False
                return True

            matching_items = [item for item in items if matches_filters(item)]
            all_matches.extend(matching_items)

            if not last_evaluated_key:
                break
            scan_kwargs['ExclusiveStartKey'] = last_evaluated_key

        return {
            "restaurantRecommendations": all_matches,
            "count": len(all_matches)
        }

    except ClientError as e:
        code = e.response['Error']['Code']
        msg = e.response['Error']['Message']
        return {"error": "Table not found." if code == 'ResourceNotFoundException' else f"DynamoDB Error: {msg}"}
    except Exception as e:
        print(f"Unhandled Error: {e}")
        traceback.print_exc()
        return {"error": f"An error occurred while retrieving the restaurant recommendations: {str(e)}"}
def lambda_handler(event, context):
    try:
        print(f"Event: {event}")
        query_params = event.get('queryStringParameters', {}) or {}
        tz_param = query_params.get('timezone')
        tz_name = tz_param or os.getenv('DEFAULT_TIMEZONE', 'Asia/Jerusalem')
        try:
            timezone = ZoneInfo(tz_name)
        except Exception:
            print(f"Invalid timezone '{tz_name}', falling back to Asia/Jerusalem")
            timezone = ZoneInfo("Asia/Jerusalem")
        print(timezone)
        style = query_params.get('style')
        vegetarian_str = query_params.get('vegetarian')
        vegetarian = vegetarian_str.lower() == 'true' if vegetarian_str else None

        open_now_str = query_params.get('open_now')
        open_now = open_now_str.lower() == 'true' if open_now_str else False

        delivery_str = query_params.get('delivery')
        delivery = delivery_str.lower() == 'true' if delivery_str else None

        address = query_params.get('address')

        page_size = int(query_params.get('pageSize', '100'))
        last_evaluated_key_str = query_params.get('lastEvaluatedKey')
        last_evaluated_key = json.loads(last_evaluated_key_str) if last_evaluated_key_str else None

        recommendation = get_restaurant_recommendation(
            style=style,
            vegetarian=vegetarian,
            open_now=open_now,
            delivery=delivery,
            address=address,
            last_evaluated_key=last_evaluated_key,
            page_size=page_size
        )

        return {
            'statusCode': 200,
            'body': json.dumps(recommendation, indent=2),
            'headers': {
                'Content-Type': 'application/json'
            }
        }

    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON in lastEvaluatedKey'}),
            'headers': {
                'Content-Type': 'application/json'
            }
        }
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': f'Internal Server Error: {e}'}),
            'headers': {
                'Content-Type': 'application/json'
            }
        }