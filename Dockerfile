# Use Python 3.11 oficial
FROM python:3.11-slim

# Configura diretório de trabalho
WORKDIR /app

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia código da aplicação
COPY . .

# Cria usuário não-root
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app
USER app

# Configura variáveis de ambiente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Expor porta
EXPOSE 8000

# Comando para executar a aplicação
ENTRYPOINT ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && exec gunicorn --bind 0.0.0.0:$PORT teste_deploy.wsgi:application"]