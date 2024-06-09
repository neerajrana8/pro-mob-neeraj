# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

To create Tutors
API URL: /courses
Type: POST
Body: {
"course": {
"name": "",
"tutors_attributes": [
{ "name": "Dr. Rana" },
{ "name": "Dr. Singh" }
]
}
}


To get tutors

API URL: /courses
Type: GET