<script lang="ts">
	import { onMount } from 'svelte';

	onMount(() => {
		fetch('http://localhost:4000/dashboard/home')
			.then((res) => res.json())
			.then((res) => console.log(res));
	});
</script>

