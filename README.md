# README

# Full Stack Backend Engineer Project

### Create an API that has the following functionality

## Data structures

### Profile
  - first name
  - last name
  - email
  
### Team
  - name
  
### Associations
- A Profile should be part of a team

## Routes
Authentication should be done through a JWT token passed in the header

### Authenticated routes

For profiles
- GET return all profiles
- GET return one profile
- POST create profile
- PUT update profile
- DELETE delete profile

### Unauthenticated routes

For profiles

- GET return all profiles
- GET return one profile

Data returned should be limited to:
- first name
- last name

## Tests
Create tests for each of the created above

## Bonus: Deploy
- Use AWS free tier or provider of your choice to deploy the app

