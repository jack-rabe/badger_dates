<script lang="ts">
	import { onMount } from 'svelte';
	import type { User } from '../../types/User';

	let user: User;

	onMount(() => {
		fetch('http://localhost:4000/api/users/a8954b3c-2450-4a83-a2d3-14b35541e8a6')
			.then((res) => res.json())
			.then((res) => {
				user = res.data;
			})
			.catch((e) => console.error(e));
	});
</script>

{#if user}
	<div class="bg-primary card m-2">
		<h3 class="card-title justify-center">{user.name}</h3>
		<div class="card-body">
			<div class="text-center">Age: {user.age}</div>
			<div class="text-center">Major: {user.major}</div>
			<div class="text-center">Location: {user.location}</div>
		</div>
	</div>
{/if}
