from django.test import TestCase
from django.contrib.auth import get_user_model

CustomUser = get_user_model()


class CustomUserTest(TestCase):

    def setUp(self) -> None:
        joes_email = "joe.doe@example.com"
        self.joe = CustomUser.objects.create_user(
            email=joes_email,
            password="password",
            first_name="joe",
            last_name="doe",
            username=joes_email,
        )

        marrys_email = "marry.jane@example.com"

        self.marry = CustomUser.objects.create_user(
            email=marrys_email,
            username=marrys_email,
            password="qwerty123",
            first_name="marry",
            last_name="jane",
        )

    def test_user_creation(self):
        """Test user is created with correct email, first and last name"""

        self.assertEqual(self.joe.email, "joe.doe@example.com")
        self.assertEqual(self.joe.first_name, "joe")
        self.assertEqual(self.joe.last_name, "doe")
        self.assertTrue(self.joe.check_password("password"))

        self.assertEqual(self.marry.email, "marry.jane@example.com")
        self.assertEqual(self.marry.first_name, "marry")
        self.assertEqual(self.marry.last_name, "jane")
        self.assertTrue(self.marry.check_password("qwerty123"))

    def test_string_representation(self):
        """Test the string representation of user"""
        self.assertEqual(str(self.joe), "joe.doe@example.com")
        self.assertEqual(str(self.marry), "marry.jane@example.com")

    def test_email_uniqueness(self):
        """Test that emails must be unique"""
        with self.assertRaises(Exception):
            CustomUser.objects.create_user(
                email="joe.doe@example.com",
                username="joe.doe@example.com",
                password="anotherpassword",
            )

    def test_google_id_blank(self):
        """Test that google_id can be blank"""
        email = "blank.google@example.com"
        user_with_blank_google_id = CustomUser.objects.create_user(
            username=email,
            email=email,
            password="password123",
            google_id="",
        )
        self.assertEqual(user_with_blank_google_id.google_id, "")

    def test_google_id_null(self):
        """Test that google_id can be null"""

        email = "null.google@example.com"

        user_with_null_google_id = CustomUser.objects.create_user(
            username=email, email=email, password="password123", google_id=None
        )
        self.assertIsNone(user_with_null_google_id.google_id)

    def test_add_friends(self):
        """Test that users can add each other as friends"""
        self.joe.friends.add(self.marry)
        self.assertIn(self.marry, self.joe.friends.all())
        self.assertIn(self.joe, self.marry.friends.all())

    def test_ordering(self):
        """Test users are ordered by last_name and first_name"""
        users = CustomUser.objects.all()
        self.assertEqual(users[0], self.joe)
        self.assertEqual(users[1], self.marry)

    def test_user_can_have_multiple_friends(self):
        """Test that a user can have multiple friends"""
        email = "john.smith@example.com"
        another_friend = CustomUser.objects.create_user(
            username=email,
            email=email,
            password="password123",
            first_name="john",
            last_name="smith",
        )
        self.joe.friends.add(self.marry, another_friend)
        self.assertIn(self.marry, self.joe.friends.all())
        self.assertIn(another_friend, self.joe.friends.all())
