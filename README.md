# Chat App

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![Django](https://img.shields.io/badge/django-%23092E20.svg?style=for-the-badge&logo=django&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

[![Django CI](https://github.com/lukaszfabia/chat-app/actions/workflows/django.yml/badge.svg)](https://github.com/lukaszfabia/chat-app/actions/workflows/django.yml)
[![Swift CI](https://github.com/lukaszfabia/chat-app/actions/workflows/swift.yml/badge.svg)](https://github.com/lukaszfabia/chat-app/actions/workflows/swift.yml)

## Description

App name is simple chat application with `REST API` and `WebSocket` server for `iOS` platform. Provides communication with other people in a **real time**.

## Functionalities

- :speech_balloon: Real time messages

- :iphone: Sign up, sign in (avaiable authentication via Google)
- :clock9: Chat history
- :heavy_plus_sign: Adding friends to friend list
- :busts_in_silhouette: Managing friends requests
- :memo: Account managing
- :no_entry_sign: User blocking
- :key: Password restoring
- :bell: Notifications (?)

## Appearance

<!-- place for mockups or real screens from app -->

## Installation - Server side

Install the required dependencies by running:

```bash
pip install -r requirements.txt
```

## Additional Commands

### Database Migrations

To set up or update database tables, run:

```bash
cd api/
python manage.py makemigrations
python manage.py migrate
```

### Start the Development Server

Run the server on a specified port (default is 8000):

```bash
cd api/
python manage.py runserver [port]
```

### Create a Superuser Account

To create an admin user, use:

```bash
cd api/
python manage.py createsuperuser
```
