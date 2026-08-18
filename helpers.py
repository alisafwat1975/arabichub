from functools import wraps

from flask import redirect, render_template, session


def apology(message, code=400):
    """
    Render an apology page.
    """

    return render_template(
        "apology.html",
        code=code,
        message=message
    ), code


def login_required(f):
    """
    Require users to be logged in before accessing a route.
    """

    @wraps(f)
    def decorated_function(*args, **kwargs):

        if session.get("user_id") is None:
            return redirect("/login")

        return f(*args, **kwargs)

    return decorated_function
