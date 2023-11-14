<script lang="ts">
	import dayjs from 'dayjs';
	import relativeTime from 'dayjs/plugin/relativeTime';
	import { onMount } from 'svelte';
	import { slide, fly } from 'svelte/transition';
  import { PUBLIC_API_URL } from '$env/static/public';

	dayjs.extend(relativeTime);

	type Post = {
		content: string;
		createdAt: Date;
	};

	let posts: Post[] = [];

	let errorMessage: string | null = null;
	let newPost: string = '';
	let loading: boolean = false;
	const addNewPost = async () => {
		if (loading) {
			return;
		}
		if (newPost === '') {
      errorMessage = 'Please type something';
			return;
		}
    loading = true;
		const response = await fetch(`${PUBLIC_API_URL}/post`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				content: newPost
			})
		});
		if (!response.ok) {
			errorMessage = 'Something went wrong';
			return;
		}
		await getPosts();
		errorMessage = null;
		loading = false;
		newPost = '';
	};

	const getPosts = async () => {
		const response = await fetch(`${PUBLIC_API_URL}/posts`);
		if (!response.ok) {
			errorMessage = 'Something went wrong';
			return;
		}
		const data = await response.json();
		posts = data;
	};

	onMount(() => {
		getPosts();
	});
</script>

<div class="absolute bottom-4 right-4 text-slate-50/30">
  by T0NG
</div>

<div class="w-full flex items-center my-20 flex-col gap-2">
	<h1 class="text-4xl">MoOo</h1>
	<div>
		<div class="flex gap-2">
			<input
				type="text"
				class="border rounded shadow flex-1 p-2"
				placeholder="Type your message here"
				bind:value={newPost}
			/>
			<button
				class="bg-yellow-500 hover:bg-yellow-600 active:bg-yellow-700 rounded border shadow px-2 py-1 text-white transition duration-100 disabled:cursor-wait"
				disabled={loading}
				on:click={addNewPost}>Sent</button
			>
		</div>
		{#if errorMessage}
			<div transition:slide class="text-red-500">{errorMessage}</div>
		{/if}
	</div>
</div>

<div class="w-full px-10 space-y-4">
	<h1 class="text-4xl">Message</h1>
	<div class="grid grid-cols-5 gap-2">
		{#each posts as item}
			<div class="w-full border rounded flex items-center p-2" transition:fly>
				<div class="flex-1">
					<div class="text-sm">
						{item.content}
					</div>
					<div class="text-xs text-gray-500">
						Posted {dayjs(new Date(item.createdAt)).fromNow()}
					</div>
				</div>
			</div>
		{/each}
		{#if posts.length === 0}
			<div class="col-span-5 text-center text-gray-500">No message yet</div>
		{/if}
	</div>
</div>
