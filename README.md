# EC2 Practice Streamlit App

This is a basic Streamlit app for practicing EC2 deployment.

## Local Development

1. Create a virtual environment (recommended):
```bash
python -m venv venv
source venv/bin/activate  # On macOS/Linux
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the app locally:
```bash
streamlit run app.py
```

## EC2 Deployment Steps

1. Launch an EC2 instance (t2.micro is sufficient for this app)
2. Configure security groups to allow inbound traffic on port 8501
3. SSH into your instance
4. Install Python and pip
5. Clone this repository
6. Install dependencies
7. Run the Streamlit app:
```bash
streamlit run app.py --server.address 0.0.0.0
```

Note: For production deployment, consider using a proper process manager like `supervisor` or running behind a reverse proxy.
