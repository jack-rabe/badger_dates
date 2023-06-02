<script lang="ts">
	import { onMount } from 'svelte';
	import type { User } from '../../types/User';

	let otherUser: User | null;
	let user: User;
	user = { id: '3a9096b3-aea7-4546-a75b-b676dc4a174e' } as User;

	onMount(() => setNextMatch());

	const setNextMatch = () => {
		fetch(`http://localhost:4000/api/links/${user.id}/next`)
			.then((res) => res.json())
			.then((res) => {
				if (res && res.data != 'no matches') otherUser = res.data;
				else otherUser = null;
				console.log(res);
			})
			.catch((e) => console.error(e));
	};

	const declineMatch = () => {
		fetch(`http://localhost:4000/api/decline_match/${user.id}/${otherUser?.id}`, {
			method: 'PATCH'
		})
			.then((res) => res.json())
			.then((res) => {
				console.log(res);
				setNextMatch();
			})
			.catch((e) => console.error(e));
	};

	const acceptMatch = () => {
		fetch(`http://localhost:4000/api/accept_match/${user.id}/${otherUser?.id}`, { method: 'PATCH' })
			.then((res) => res.json())
			.then((res) => {
				console.log(res);
				setNextMatch();
			})
			.catch((e) => console.error(e));
	};
</script>

{#if otherUser}
	<div class="m-2">
		<div class="avatar mb-3 justify-center">
			<div class="w-5/6 rounded-full ring ring-primary md:w-2/5">
				<img src={otherUser.image_url} alt="profile pictue" />
			</div>
		</div>
		<div class="flex flex-col items-center">
			<div class="mb-2 flex w-3/4 justify-center">
				<span class="mr-2 text-3xl font-bold">{otherUser.name}</span>
				<span class="flex items-end text-2xl">{otherUser.age}</span>
			</div>
			<div>{otherUser.location}</div>
			<div>{otherUser.major}</div>
		</div>
		<div class="flex justify-center">
			<div class="mx-4 flex w-full justify-between md:w-1/2">
				<button on:click={declineMatch} class="btn-circle btn-lg btn p-2 hover:btn-primary">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						class="h-20 w-20"
						fill="none"
						viewBox="0 8 24 24"
						stroke="currentColor"
						><path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M6 18L18 6M6 6l12 12"
						/></svg
					>
				</button>
				<button on:click={acceptMatch} class="btn-circle btn-lg btn p-2 hover:btn-primary">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						class="h-20 w-20"
						fill="none"
						viewBox="0 8 24 24"
						stroke="currentColor"
						><path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
						/></svg
					>
				</button>
			</div>
		</div>
	</div>
{/if}
