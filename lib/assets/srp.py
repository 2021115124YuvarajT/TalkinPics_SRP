import json
import nltk
from nltk.corpus import words

# Download NLTK resources (if not already downloaded)
nltk.download('words')

# Load the English words corpus from NLTK
english_words = set(words.words())

# Load the JSON data with error handling
try:
    with open(r'C:\Users\YUVARAJ T\Desktop\flutter\aac_srp\lib\assets\english_category.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
except FileNotFoundError:
    print("Error: JSON file not found.")
    data = None
except json.JSONDecodeError as e:
    print(f"Error decoding JSON: {e}")
    data = None

# Proceed only if the JSON data is successfully loaded
if data:
    # Function to find the most commonly used English word from the given text
    def select_text(texts):
        valid_words = [word.strip().lower() for text in texts for word in text.split(',') if word.strip().lower() in english_words]
        if valid_words:
            return max(valid_words, key=lambda x: valid_words.count(x))
        else:
            # If no valid words found, return the word with maximum length
            return max(texts, key=len).strip()

    # Iterate through each category
    for category in data['categories']:
        # Iterate through each image and update the text property
        for image in category['imageIds']:
            image['text'] = [select_text(image['text'])]

    # Save the updated JSON data
    with open(r'C:\Users\YUVARAJ T\Desktop\flutter\aac_srp\lib\assets\english_category_updated.json', 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)
