const fields = {
  hostname: document.querySelector('#hostname'),
  serverIp: document.querySelector('#server-ip'),
  instanceName: document.querySelector('#instance-name'),
  timestamp: document.querySelector('#timestamp'),
  refreshStatus: document.querySelector('#refresh-status')
};

const infoCards = document.querySelectorAll('.info-card');

function setText(element, value) {
  element.textContent = value || 'No disponible';
}

function animateCards() {
  infoCards.forEach((card) => {
    card.classList.remove('is-updating');
    void card.offsetWidth;
    card.classList.add('is-updating');
  });
}

async function loadServerInfo() {
  try {
    fields.refreshStatus.classList.remove('has-error');
    fields.refreshStatus.textContent = 'Consultando servidor...';

    const response = await fetch('/api/info', { cache: 'no-store' });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    setText(fields.hostname, data.hostname);
    setText(fields.serverIp, data.server_ip);
    setText(fields.instanceName, data.instance_name);
    setText(fields.timestamp, data.timestamp);
    fields.refreshStatus.textContent = 'Actualizando cada 5 segundos';
    animateCards();
  } catch (error) {
    fields.refreshStatus.classList.add('has-error');
    fields.refreshStatus.textContent = 'No se pudo actualizar la informacion del servidor';
    console.error('Error al consultar /api/info:', error);
  }
}

loadServerInfo();
setInterval(loadServerInfo, 5000);
