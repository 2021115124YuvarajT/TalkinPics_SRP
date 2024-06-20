import json

# Load the JSON data
with open(r'C:\Users\YUVARAJ T\Desktop\flutter\aac_srp\lib\assets\tamil_category.json', 'r', encoding='utf-8') as file:
    data = json.load(file)

# Function to select the word with the minimum length from a list of words
def select_text(texts):
    return min(texts, key=len).strip()

# Iterate through each category
for category in data['categories']:
    # Iterate through each image and update the text property
    for image in category['imageIds']:
        if len(image['text']) > 1:
            image['text'] = [select_text(image['text'])]

# Save the updated JSON data
with open(r'C:\Users\YUVARAJ T\Desktop\flutter\aac_srp\lib\assets\tamil_category_updated.json', 'w', encoding='utf-8') as file:
    json.dump(data, file, ensure_ascii=False, indent=4)
