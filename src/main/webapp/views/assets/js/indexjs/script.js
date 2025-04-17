
// Navbar scroll effect
 window.addEventListener('scroll', () => {
const navbar = document.querySelector('.navbar');
	if (window.scrollY > 50) {
		navbar.classList.add('scrolled');
	} else {
		navbar.classList.remove('scrolled');
	}
});

// Hamburger toggle with animation
document.addEventListener('DOMContentLoaded', () => {
	const hamburger = document.querySelector('.hamburger');
	const navLinks = document.querySelector('.nav-links');
	if (hamburger && navLinks) {
		hamburger.addEventListener('click', () => {
			hamburger.classList.toggle('active');
			navLinks.classList.toggle('active');
			console.log("Hamburger clicked, nav-links toggled");
		});
	} else {
		console.error("Hamburger or nav-links not found!");
	}
});

// Section visibility on scroll
window.addEventListener('scroll', () => {
	const sections = document.querySelectorAll('.section');
	sections.forEach(section => {
		const sectionTop = section.getBoundingClientRect().top;
		const windowHeight = window.innerHeight;
		if (sectionTop < windowHeight * 0.8) {
			section.classList.add('visible');
		}
	});
});
