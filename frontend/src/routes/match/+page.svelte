<script lang="ts">
	import { onMount } from 'svelte';
	import type { User } from '../../types/User';

	let otherUser: User;
	let user: User;
	user = { id: '3a9096b3-aea7-4546-a75b-b676dc4a174e' } as User;

	onMount(() => {
		fetch(`http://localhost:4000/api/links/${user.id}/next`)
			.then((res) => res.json())
			.then((res) => {
				if (res && res.data && res.data != 'no matches') otherUser = res.data;
				console.log(res);
			})
			.catch((e) => console.error(e));
	});

	const declineMatch = () => {
		fetch(`http://localhost:4000/api/decline_match/${user.id}/${otherUser.id}`, {
			method: 'PATCH'
		})
			.then((res) => res.json())
			.then((res) => {
				console.log(res);
			})
			.catch((e) => console.error(e));
	};

	const acceptMatch = () => {
		fetch(`http://localhost:4000/api/accept_match/${user.id}/${otherUser.id}`, { method: 'PATCH' })
			.then((res) => res.json())
			.then((res) => {
				console.log(res);
			})
			.catch((e) => console.error(e));
	};
</script>

{#if otherUser}
	<div class="bg-primary card m-2">
		<h3 class="card-title justify-center">{otherUser.name}</h3>
		<div class="card-body">
			<div class="text-center">Age: {otherUser.age}</div>
			<div class="text-center">Location: {otherUser.location}</div>
			<div class="text-center">Major: {otherUser.major}</div>
		</div>
	</div>
	<div class="flex justify-between">
		<button on:click={declineMatch} class="btn w-32 m-2">skip</button>
		<button on:click={acceptMatch} class="btn w-32 m-2">match</button>
	</div>
{/if}
