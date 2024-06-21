from flask import Flask, request, send_file
from rembg import remove
from PIL import Image
import io
from flask_cors import CORS
import logging

app = Flask(__name__)
CORS(app)  # This enables CORS for all routes

logging.basicConfig(level=logging.DEBUG)

@app.route('/remove_background', methods=['POST'])
def remove_background():
    if 'image' not in request.files:
        app.logger.error('No image uploaded')
        return 'No image uploaded', 400
    
    file = request.files['image']
    app.logger.info(f'Received image: {file.filename}')
    
    try:
        input_image = Image.open(file.stream)
        app.logger.info(f'Image opened successfully. Size: {input_image.size}')
        
        # Remove background
        app.logger.info('Removing background...')
        output = remove(input_image)
        app.logger.info('Background removed successfully')
        
        # Save the result to a byte stream
        img_byte_arr = io.BytesIO()
        output.save(img_byte_arr, format='PNG')
        img_byte_arr.seek(0)
        
        app.logger.info('Sending processed image back')
        return send_file(img_byte_arr, mimetype='image/png')
    
    except Exception as e:
        app.logger.error(f'Error processing image: {str(e)}')
        return f'Error processing image: {str(e)}', 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)