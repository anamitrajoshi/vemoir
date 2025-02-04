from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
import pymongo
import jwt
from functools import wraps

app = Flask(__name__)
app.config['SECRET_KEY'] = 'helloworld'

# MongoDB configuration
app.config['MONGO_URI'] = 'mongodb+srv://Admin:Akanksha@8136@vemoir.jvitq.mongodb.net/vemoir?retryWrites=true&w=majority&appName=Vemoir'
mongo = PyMongo(app)
db = mongo.db

# User Schema (MongoDB collection 'users')
users_collection = db.users

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

    # Insert new user
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

@app.route('/videos', methods=['POST'])
@token_required
def add_video(current_user):
    data = request.get_json()
    data['username'] = current_user  # Associate video with uploader
    db.videos.insert_one(data)
    return jsonify({'message': 'Video saved successfully!'})

@app.route('/videos', methods=['GET'])
@token_required
def get_videos(current_user):
    videos = db.videos.find({'username': current_user})
    output = [{'title': video['title'], 'description': video['description']} for video in videos]
    return jsonify({'videos': output})

if __name__ == '__main__':
    app.run(debug=True)

