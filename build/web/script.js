const images = document.querySelectorAll('.image');
let currentIndex = 0;
let intervalId;

function autoRotate() {
    images[currentIndex].style.transform = 'scale(1)';
    currentIndex = (currentIndex + 1) % images.length;
    images[currentIndex].style.transform = 'scale(1.1)';
}

function stopRotation() {
    clearInterval(intervalId);
}

images.forEach((image, index) => {
    image.style.setProperty('--i', index);
    image.addEventListener('click', () => {
        images[currentIndex].style.transform = 'scale(1)';
        currentIndex = index;
        images[currentIndex].style.transform = 'scale(1.1)';
        stopRotation();
    });
});

intervalId = setInterval(autoRotate, 3000); // Cambia de imagen cada 3 segundos (ajusta según tus preferencias)
