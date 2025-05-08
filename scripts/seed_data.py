import boto3
import os
from decimal import Decimal
import uuid
from botocore.exceptions import ClientError

def seed_restaurants():
    # Get the table name from environment variable
    table_name = os.getenv('DYNAMODB_TABLE_NAME')
    if not table_name:
        raise ValueError("DYNAMODB_TABLE_NAME environment variable is not set")

    # Initialize DynamoDB client
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)

    # Sample restaurant data
    restaurants = [
        {
            'id': str(uuid.uuid4()),
            'name': 'Taco Fiesta',
            'style': 'Mexican',
            'vegetarian': 'true',
            'address': '321 Elm St',
            'openHour': '09:00',
            'closeHour': '20:00',
            'delivery': 'true'
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Sushi Master',
            'style': 'Japanese',
            'vegetarian': 'true',
            'address': '789 Pine Rd',
            'openHour': '10:00',
            'closeHour': '21:00',
            'delivery': 'true'
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Le Bistro',
            'style': 'French',
            'vegetarian': 'true',
            'address': '456 Oak Ave',
            'openHour': '12:00',
            'closeHour': '23:00',
            'delivery': 'false'
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Burger Joint',
            'style': 'American',
            'vegetarian': 'false',
            'address': '654 Maple Dr',
            'openHour': '11:00',
            'closeHour': '23:00',
            'delivery': 'true'
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Pizza Palace',
            'style': 'Italian',
            'vegetarian': 'true',
            'address': '123 Main St',
            'openHour': '11:00',
            'closeHour': '22:00',
            'delivery': 'true'
        }
    ]

    try:
        # Use batch_writer for efficient batch writing
        with table.batch_writer() as batch:
            for restaurant in restaurants:
                batch.put_item(Item=restaurant)
        print(f"Successfully seeded {len(restaurants)} restaurants into {table_name}")
    except Exception as e:
        print(f"Error seeding data: {str(e)}")

if __name__ == "__main__":
    seed_restaurants() 