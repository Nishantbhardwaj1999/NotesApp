# Stage 1: Build the frontend
FROM node:14 AS frontend-builder

# Set the working directory in the container
WORKDIR /app/frontend

# Copy package.json and package-lock.json to the working directory
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy the entire frontend project to the working directory
COPY frontend .

# Build the React app
RUN npm run build


# Stage 2: Build the backend
FROM python:3.9 AS backend-builder

# Set the working directory in the container
WORKDIR /app/backend

# Copy the backend files to the working directory
COPY backend/requirements.txt .
COPY backend/app.py .

# Install Flask and other dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Stage 3: Combine frontend and backend into a single image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the built frontend files from the frontend-builder stage
COPY --from=frontend-builder /app/frontend/build ./frontend

# Copy the built backend files from the backend-builder stage
COPY --from=backend-builder /app/backend ./

# Expose port 5000 for the Flask backend
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "app.py"]
