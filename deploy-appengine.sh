#!/bin/bash

# Google App Engine Deployment Script for Open Lovable

echo "🚀 Deploying Open Lovable to Google App Engine..."

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI is not installed. Please install it first:"
    echo "   https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n 1 > /dev/null; then
    echo "❌ Error: Not authenticated with gcloud. Run: gcloud auth login"
    exit 1
fi

# Set project ID (replace with your actual project ID)
read -p "Enter your Google Cloud Project ID: " PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo "❌ Error: Project ID is required"
    exit 1
fi

gcloud config set project $PROJECT_ID

echo "📝 Setting up environment variables..."

# Set environment variables using Secret Manager (recommended) or direct env vars
echo "Setting API keys as environment variables..."

# Option 1: Set environment variables directly in app.yaml
echo "Please update app.yaml with your API keys, or use Secret Manager for better security."

# Option 2: Use Secret Manager (recommended for production)
read -p "Do you want to use Secret Manager for API keys? (y/n): " USE_SECRETS

if [ "$USE_SECRETS" = "y" ]; then
    echo "🔐 Setting up Secret Manager..."
    
    # Enable Secret Manager API
    gcloud services enable secretmanager.googleapis.com
    
    # Create secrets (you'll need to add the actual values)
    echo "Creating secrets... (you'll need to add values manually)"
    gcloud secrets create firecrawl-api-key --data-file=- <<< "your_firecrawl_api_key"
    gcloud secrets create anthropic-api-key --data-file=- <<< "your_anthropic_api_key"
    gcloud secrets create openai-api-key --data-file=- <<< "your_openai_api_key"
    gcloud secrets create e2b-api-key --data-file=- <<< "your_e2b_api_key"
    
    echo "⚠️  Remember to update the secret values with: gcloud secrets versions add SECRET_NAME --data-file=file_with_secret"
fi

echo "🔧 Enabling required APIs..."
gcloud services enable appengine.googleapis.com
gcloud services enable cloudbuild.googleapis.com

echo "📦 Building and deploying..."

# Deploy to App Engine
gcloud app deploy app.yaml --quiet

echo "✅ Deployment complete!"

# Get the deployed URL
APP_URL=$(gcloud app browse --no-launch-browser 2>/dev/null || echo "https://$PROJECT_ID.uc.r.appspot.com")

echo ""
echo "🌐 Your app is now live at: $APP_URL"
echo ""
echo "📋 Next steps:"
echo "1. Update your API keys in the App Engine console or Secret Manager"
echo "2. Test the health endpoint: $APP_URL/api/health"
echo "3. Monitor logs with: gcloud app logs tail -s default"
echo ""
echo "🔍 Useful commands:"
echo "  - View logs: gcloud app logs tail -s default"
echo "  - Update: gcloud app deploy"
echo "  - Stop: gcloud app versions stop VERSION"
echo "  - Delete: gcloud app versions delete VERSION"