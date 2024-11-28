# Gocrowd Backend

Gocrowd Backend is a Ruby on Rails application designed to manage and serve the backend functionalities for the Gocrowd project.

## Author
OpenClade

## Prerequisites
- Docker
- Docker Compose

## Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/OpenClade/gocrowd.git
    cd gocrowd
    ```

2. Create and configure the `.env` file:
    ```sh
    cp .env.example .env
    ```

3. Build and start the Docker containers:
    ```sh
    docker-compose up --build
    ```

4. Setup the database:
    ```sh
    docker-compose run app rake db:create db:migrate db:seed
    ```

## Running the Application

1. Start the application:
    ```sh
    docker-compose up
    ```

2. The application will be available at `http://localhost:3000`.

## Additional Information

- **Ruby version**: 3.0.2
- **Rails version**: 7.1
- **Database**: PostgreSQL

## Services

- **Database**: PostgreSQL running on port 5432
- **PgAdmin**: Accessible at `http://localhost:5050` with credentials from `.env` file

## Deployment Instructions

- Ensure all environment variables are set correctly in the `.env` file.
- Use Docker and Docker Compose to manage and deploy the application.

For more detailed instructions, refer to the official documentation of Docker and Docker Compose.