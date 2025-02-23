curl "https://randomwordgenerator.com/json/sentences.json" | jq .data | jq .[] | jq .sentence
