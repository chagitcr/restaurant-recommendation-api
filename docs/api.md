# API Documentation

## Endpoints

### Get Restaurant Recommendations
```
GET /recommendations
```

#### Query Parameters
- `style` (optional): Cuisine style (e.g., "Italian", "Japanese")
- `vegetarian` (optional): "true" or "false"
- `location` (optional): Area name (e.g., "Downtown")

#### Example Request
```bash
curl -X GET "https://<api-id>.execute-api.<region>.amazonaws.com/dev/recommendations?style=Italian&vegetarian=true"
```

#### Example Response
```json
{
  "recommendations": [
    {
      "id": "1",
      "name": "Pasta Paradise",
      "style": "Italian",
      "vegetarian": "true",
      "location": "Downtown",
      "opening_hours": "11:00",
      "closing_hours": "22:00"
    }
  ]
}
```

#### Response Codes
- 200: Success
- 400: Bad Request
- 500: Internal Server Error

#### Error Response Format
```json
{
  "error": "Error message description"
}
``` 