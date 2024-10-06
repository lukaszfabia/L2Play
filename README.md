# Chat App

[![Django CI](https://github.com/lukaszfabia/chat-app/actions/workflows/django.yml/badge.svg)](https://github.com/lukaszfabia/chat-app/actions/workflows/django.yml)
[![Swift CI](https://github.com/lukaszfabia/chat-app/actions/workflows/swift.yml/badge.svg)](https://github.com/lukaszfabia/chat-app/actions/workflows/swift.yml)

## Description

App name is simple chat appliaction with REST API and WebSocket server for iOS platform.

## Installation

To install the required dependencies, run:

```bash
pip install -r requirements.txt
```

## Other helpful commands

Migrate tables and date if its needed:

```bash
cd api/
python manage.py makemigrations
python manage.py migrate
```

Run server on given port, default its 8000

```bash
cd api/
python manage.py runserver :port?
```

Create super user (admin)

```bash
cd api/
python manage.py createsuperuser
```
