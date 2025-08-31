#!/bin/bash

# Gemini Chatbot Setup Script for Linux/macOS
# This script automates the creation of a Gemini chatbot with virtual environment

echo "🤖 Starting Gemini Chatbot Setup..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if Python is installed
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✅ Python found: $PYTHON_VERSION${NC}"
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    echo -e "${GREEN}✅ Python found: $PYTHON_VERSION${NC}"
    PYTHON_CMD="python"
else
    echo -e "${RED}❌ Python not found! Please install Python first.${NC}"
    exit 1
fi

# Check if pip is installed
if command -v pip3 &> /dev/null; then
    PIP_CMD="pip3"
elif command -v pip &> /dev/null; then
    PIP_CMD="pip"
else
    echo -e "${RED}❌ pip not found! Please install pip first.${NC}"
    exit 1
fi

# Create project directory if it doesn't exist
PROJECT_NAME="gemini_chatbot"
if [ ! -d "$PROJECT_NAME" ]; then
    mkdir "$PROJECT_NAME"
    echo -e "${GREEN}📁 Created project directory: $PROJECT_NAME${NC}"
fi

# Navigate to project directory
cd "$PROJECT_NAME"
echo -e "${BLUE}📂 Working in: $(pwd)${NC}"

# Create virtual environment
echo -e "${YELLOW}🔧 Creating virtual environment...${NC}"
$PYTHON_CMD -m venv venv

if [ -d "venv" ]; then
    echo -e "${GREEN}✅ Virtual environment created successfully!${NC}"
else
    echo -e "${RED}❌ Failed to create virtual environment!${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${YELLOW}🚀 Activating virtual environment...${NC}"
source venv/bin/activate

# Upgrade pip
# echo -e "${YELLOW}📦 Upgrading pip...${NC}"
# $PIP_CMD install --upgrade pip

# Install required packages
echo -e "${YELLOW}📦 Installing required packages...${NC}"
packages=("google-generativeai" "python-dotenv")

for package in "${packages[@]}"; do
    echo -e "${CYAN}Installing $package...${NC}"
    $PIP_CMD install "$package"
done

echo -e "${GREEN}✅ All packages installed successfully!${NC}"

# Create the chatbot Python file
echo -e "${YELLOW}📝 Creating chatbot.py...${NC}"
cat > chatbot.py << 'EOF'
import os
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise ValueError("API key not found! Ensure .env has GEMINI_API_KEY set.")

genai.configure(api_key=api_key)

# Include the system instruction here:
model = genai.GenerativeModel(
    model_name="models/gemini-1.5-flash-latest",
    system_instruction=(
        "WHEN SOMEONE ASK U WHO U ARE : ANSWER I AM VISHWAS THE GOAT OF KERALA"
        "📝 Answer:\n<your full explanation>\n\n📌 Summary:\n<1-2 sentence summary>"
    )
)

chat = model.start_chat()

print("💬 Gemini Flash 2.5 (CLI) with system prompt — type 'exit' to quit\n")

while True:
    user_input = input("You > ")
    if user_input.lower() in ["exit", "quit"]:
        break
    try:
        response = chat.send_message(user_input)
        print("Gemini >", response.text.strip(), "\n")
    except Exception as e:
        print("⚠️ Error:", e)
EOF

echo -e "${GREEN}✅ chatbot.py created successfully!${NC}"

# Create .env file template
echo -e "${YELLOW}📝 Creating .env template...${NC}"
echo "GEMINI_API_KEY=$GEMINI_API_KEY" > .env

echo -e "${GREEN}✅ .env template created!${NC}"



# Create requirements.txt
echo -e "${YELLOW}📝 Creating requirements.txt...${NC}"
cat > requirements.txt << 'EOF'
google-generativeai>=0.3.0
python-dotenv>=1.0.0
EOF

echo -e "${GREEN}✅ requirements.txt created!${NC}"

# Create README.md
echo -e "${YELLOW}📝 Creating README.md...${NC}"
cat > README.md << 'EOF'
# Gemini Chatbot

A simple command-line chatbot using Google's Gemini AI.

## Setup

1. Get your Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add your API key to the `.env` file:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

## Usage

1. Activate the virtual environment:
   ```bash
   source venv/bin/activate
   ```

2. Run the chatbot:
   ```
   python chatbot.py
   ```

3. Start chatting! Type 'exit' or 'quit' to stop.

## Files

- `chatbot.py` - Main chatbot script
- `.env` - Environment variables (add your API key here)
- `requirements.txt` - Python dependencies
- `venv/` - Virtual environment

## Features

- Interactive command-line chat
- Custom system instructions
- Error handling
- Clean exit functionality
EOF

echo -e "${GREEN}✅ README.md created!${NC}"

# Final instructions
echo ""
echo -e "${GREEN}🎉 SETUP COMPLETE!${NC}"
echo "=================================================="
echo ""
echo -e "${CYAN}📋 Next Steps:${NC}"
echo -e "${NC}1. Edit the .env file and add your Gemini API key${NC}"
echo -e "${NC}2. Get your API key from: https://makersuite.google.com/app/apikey${NC}"
echo -e "${NC}3. Run the chatbot with: python chatbot.py${NC}"
echo ""
echo -e "${BLUE}📁 Project created in: $(pwd)${NC}"
echo -e "${GREEN}🔧 Virtual environment is already activated!${NC}"
echo ""
echo -e "${YELLOW}💡 To run your chatbot:${NC}"
echo -e "${NC}   python chatbot.py${NC}"
echo ""
echo -e "${YELLOW}💡 To activate virtual environment later:${NC}"
echo -e "${NC}   source venv/bin/activate${NC}"


# curl -H "Authorization: Bearer mysecret123" \
#      https://chatbot-nitr0x.vercel.app/api/get-env
