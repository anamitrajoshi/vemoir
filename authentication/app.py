from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
import pymongo
import jwt
from jwt import encode
# import pyjwt as jwt
from functools import wraps
from datetime import datetime
import urllib.parse
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your_secret_key'  
username = "yourusername"  # Your MongoDB username
password = "yourpassword"  # Your MongoDB password

encoded_username = urllib.parse.quote_plus(username)
encoded_password = urllib.parse.quote_plus(password)

uri = f"mongodb+srv://{encoded_username}:{encoded_password}@vemoir.czk7p.mongodb.net/?retryWrites=true&w=majority&appName=Vemoir"
# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))
# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)

db = client.vemoirdb
users_collection = db.users
videos_collection = db.videos

# JWT Token verification decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'message': 'Token is missing!'}), 401

        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token is expired!'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Invalid token!'}), 401

        return f(data['user'], *args, **kwargs)

    return decorated

# Routes
@app.route('/signin', methods=['POST'])
def create_user():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    if not username or not email or not password:
        return jsonify({'message': 'All fields are required!'}), 400

    existing_user = users_collection.find_one({'email': email})
    if existing_user:
        return jsonify({'message': 'Email already registered!'}), 400

    users_collection.insert_one({'username': username, 'email': email, 'password': password})
    return jsonify({'message': 'User created successfully!'}), 200


@app.route('/login', methods=['POST'])
def login():
    auth = request.authorization

    if not auth or not auth.username or not auth.password:
        return jsonify({'message': 'Could not verify!'}), 401

    user = users_collection.find_one({'username': auth.username, 'password': auth.password})
    if not user:
        return jsonify({'message': 'Invalid credentials!'}), 401

    token = jwt.encode({'user': auth.username}, app.config['SECRET_KEY'], algorithm="HS256")
    return jsonify({'token': token})


@app.route('/save_video', methods=['POST'])
@token_required
def save_video(current_user):
    data = request.get_json()
    
    video_path = data.get('video_path')
    tags = data.get('tags', [])
    people = data.get('people', [])
    timestamp = data.get('timestamp')

    if not video_path or not timestamp:
        return jsonify({'message': 'Video path and timestamp are required!'}), 400
    
    try:
        upload_time = datetime.strptime(timestamp, '%Y-%m-%dT%H:%M:%SZ')
    except ValueError:
        return jsonify({'message': 'Invalid timestamp format! Use ISO format (YYYY-MM-DDTHH:MM:SSZ)'}), 400

    video_data = {
        'username': current_user,
        'video_path': video_path,
        'tags': tags,
        'people': people,
        'upload_time': upload_time
    }

    videos_collection.insert_one(video_data)
    return jsonify({'message': 'Video saved successfully!'}), 201

@app.route('/get_videos', methods=['GET'])
@token_required
def get_videos(current_user):
    videos = videos_collection.find({'username': current_user})
    
    output = []
    for video in videos:
        output.append({
            'video_path': video.get('video_path'),
            'tags': video.get('tags', []),
            'people': video.get('people', []),
            'timestamp': video.get('upload_time').strftime('%Y-%m-%dT%H:%M:%SZ')
        })
    
    return jsonify({'videos': output}), 200


if __name__ == '__main__':
    app.run(debug=True)
