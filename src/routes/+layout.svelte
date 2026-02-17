<script lang="ts">
	import './layout.css';
	import favicon from '$lib/assets/favicon.svg';

	let { children } = $props();
</script>

<nav class="bg-blue-500 text-white w-full mx-auto font-bold mb-4">This is the navbar</nav>
{@render children()}
