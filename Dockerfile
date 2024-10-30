FROM python:3.12.7

#this is the working directory in the container.
WORKDIR /usr/src/META/Registrering

#this is to prevent python from writing pyc file.
ENV PYTHONDONTWRITEBYTECODE 1
#we add this to prevent python from buffering output to the terminal
ENV PYTHONUNBUFFERED 1
#should we run a upgrade and install? feel free to let me know.  RUN pip install --upgrade pip

#As iv understood, this gives us the ability to reads and write to the networking using TCP, or UDP. 
RUN apt-get update && apt-get install -y netcat-openbsd && apt-get clean

#this just copies the requirements.txt file into the current directory.
COPY ./requirements.txt .
RUN pip install -r requirements.txt

#copies the entrypoint file.
COPY ./entrypoint.sh .

#this is to make the entrypoint file executable. https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html
RUN sed -i 's/\r$//g' entrypoint.sh 

RUN chmod +x entrypoint.sh

#this just copies the django projext into the working dir.
COPY . .

ENTRYPOINT [ "/usr/src/META/Registrering/entrypoint.sh"]

