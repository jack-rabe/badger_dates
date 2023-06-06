<script lang="ts">
	import { onMount } from 'svelte';
	import type { Message } from '../../types/Message';

	let messages: Message[] = [];
	const linkId = '74407b56-952a-4215-aec4-dafa4057b8f6';
	const userId = '28db6b2a-6a32-4e0d-b864-c9d5295bd66b';

	onMount(() => {
		fetch(`http://localhost:4000/api/messages?user_link=${linkId}`)
			.then((res) => res.json())
			.then((res) => {
				console.log(res);
				messages = res.data;
			})
			.catch((e) => console.error(e));
	});
</script>

{#each messages as msg}
	{#if msg.user === userId}
		<div class="chat chat-start m-2">
			<div class="chat-bubble chat-bubble-primary md:text-2xl">{msg.content}</div>
		</div>
	{:else}
		<div class="chat chat-end m-2">
			<div class="chat-bubble chat-bubble-secondary text-xl md:text-2xl">{msg.content}</div>
		</div>
	{/if}
{/each}
