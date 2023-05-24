<script lang="ts">
	import NewUserForm from './form.svelte';
	import { onMount } from 'svelte';
	type User = { name: string; age: number };
	let users: User[] = [];

	onMount(() => {
		fetch('http://localhost:4000/api/users')
			.then((res) => res.json())
			.then((res) => {
				users = res.data;
			});
	});
</script>

<NewUserForm />
<!-- <h1>Users</h1> -->
<!-- {#each users as user} -->
<!-- 	<div>{user.name}</div> -->
<!-- {/each} -->
