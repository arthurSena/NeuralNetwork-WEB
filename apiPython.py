#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json,  re, requests
from flask import Flask, request, make_response
from werkzeug.exceptions import NotFound, BadRequest
from functools import wraps

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

@app.after_request
def add_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Authorization'
    response.headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    return response

@app.route('/singlelayer')
def singlelayer():
	'''Metodo simples que faz uma requisição para um método da API do R chamada OpenCPU
	que cria e testa uma rede'''
	
	train = request.args.get('train')
	test = request.args.get('test')

	size = request.args.get('size')
	decay = request.args.get('decay')
    
	maxit = request.args.get('maxit')
	target = request.args.get('target')

	param = {
            'train': '"%s"' % train,
            'test': '"%s"' % test,
            'size': size,
            'decay': decay,
            'maxit' : maxit,
            'target' : '"%s"' % target,
        }
	response = requests.post('http://localhost:2743/ocpu/library/singlenetwork/R/create_and_test/print', data = param).text
	return str(response).replace('\n', '<br/>').replace(" ", '&nbsp')

if __name__ == "__main__":
    app.run(debug = True)