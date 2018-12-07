from flask import Flask
 
app = Flask(__name__)
 
@app.route('/')
def helloWorldHandler():
    return 'Hello World from Terraform on Google Cloud!'
 
app.run(host='0.0.0.0', port=5000)
