
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualizar Ubuntu e instalar SSH, sudo y Python
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-apt \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario ansible con contraseña ansible
RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd

# Permitir sudo sin contraseña
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible

# Configurar SSH
RUN mkdir -p /var/run/sshd \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Puerto SSH
EXPOSE 22

# Iniciar servidor SSH
CMD ["/usr/sbin/sshd", "-D"]
