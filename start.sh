#!/bin/bash

# Script de inicialização para Railway/Heroku
# Executa migrations, collectstatic e inicia o servidor

echo "🚀 Iniciando deploy..."

# Executa migrations
echo "📊 Executando migrations..."
python manage.py migrate

# Coleta arquivos estáticos
echo "📁 Coletando arquivos estáticos..."
python manage.py collectstatic --noinput

# Define porta (Railway usa $PORT, local usa 8000)
PORT=${PORT:-8000}
echo "🌐 Iniciando servidor na porta $PORT..."

# Inicia o Gunicorn
exec gunicorn --bind 0.0.0.0:$PORT teste_deploy.wsgi:application 