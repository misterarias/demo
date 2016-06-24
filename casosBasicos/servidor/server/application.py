from flask import Flask
from flask import jsonify
from flask import request

import json

app = Flask(__name__)
redisConnection = None

@app.route('/', strict_slashes=False)
def index():
    params = request.args
    return jsonify({"status": "ok", "params": params})

if __name__ == '__main__':
    app.run(debug=True, threaded=True, host='0.0.0.0', port=80)
