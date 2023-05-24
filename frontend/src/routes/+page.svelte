<script lang="ts">
	import type { User } from '../types/User';
	import NewUserForm from './form.svelte';
	import { onMount } from 'svelte';
	let users: User[] = [];

	onMount(() => {
		fetch('http://localhost:4000/api/users')
			.then((res) => res.json())
			.then((res) => {
				users = res.data;
			})
			.catch((e) => console.error(e));
	});
</script>

<NewUserForm />
<!-- <h1>Users</h1> -->
<!-- {#each users as user} -->
<!-- 	<div>{user.name}</div> -->
<!-- {/each} -->
