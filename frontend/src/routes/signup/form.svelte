<script lang="ts">
	const locationOptions = ['Southeast', 'Lakeshore', 'Off-Campus'];
	let form: HTMLFormElement;

	async function handleSubmit(_e: Event) {
		const formData = new FormData(form);

		// @ts-ignore
		fetch(this.action, {
			method: 'POST',
			body: formData
		})
			.then((res) => res.json())
			.then((_res) => (window.location.href = '/match'))
			.catch((e) => console.error(e));
	}
</script>

<form bind:this={form} on:submit|preventDefault={handleSubmit} class="form-control m-4 gap-4">
	<label class="input-group w-3/4 md:w-1/2">
		<span class="w-28">Name</span>
		<input name="name" type="text" required class="input-bordered input w-full" />
	</label>
	<label class="input-group w-3/4 md:w-1/2">
		<span class="w-28">Email</span>
		<input
			name="email"
			type="email"
			pattern=".+@wisc.edu"
			required
			class="input-bordered input w-full"
		/>
	</label>
	<label class="input-group w-3/4 md:w-1/2">
		<span class="w-28">Age</span>
		<input name="age" type="number" required class="input-bordered input w-full" />
	</label>
	<label class="input-group w-3/4 md:w-1/2">
		<span class="w-28">Major</span>
		<input name="major" type="text" required class="input-bordered input w-full" />
	</label>

	<label class="input-group w-3/4 md:w-1/2">
		<span>Location</span>
		<!-- TODO fix this width -->
		<select name="location" required class="select-bordered select w-3/4">
			<option selected disabled />
			{#each locationOptions as opt}
				<option>{opt}</option>
			{/each}
		</select>
	</label>

	<div class="form-control">
		<label for="profile-picture" class="label">
			<span class="label-text">Pick a profile picture</span>
		</label>
		<input
			id="profile-picture"
			name="profile-picture"
			type="file"
			required
			accept="image/*"
			class="file-input-bordered file-input max-w-xs"
		/>
	</div>

	<button class="btn" type="submit">Submit</button>
</form>
