import adapter from '@sveltejs/adapter-static';

/** @type {import('@sveltejs/kit').Config} */
const config = { kit: { adapter: adapter({
            		strict: false, // You might need this if you have dynamic routes
            		fallback: 'index.html' // <--- REQUIRED for SPA mode
        	}) } };

export default config;
