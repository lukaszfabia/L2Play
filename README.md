# app name

## Backend (REST API)

Server of a iOS moblie app.

**Install dependencies:**

```bash
pip install -r requirements.txt
```

Migare tables and date if its needed:

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
