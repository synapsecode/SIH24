from flask import render_template, request, Blueprint, redirect
main = Blueprint('main', __name__)

@main.route("/")
def main_home():
	return redirect('https://trashtagweb.vercel.app'), 301
