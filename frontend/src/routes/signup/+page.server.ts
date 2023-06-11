import type { Actions } from './$types';
import { v2 as cloudinary } from 'cloudinary';

export const actions = {
	default: async ({ request }) => {
		cloudinary.config({
			cloud_name: process.env.CLOUD_NAME,
			api_key: process.env.API_KEY,
			api_secret: process.env.API_SECRET
		});

		const formData = await request.formData();
		const picFile = formData.get('profile-picture') as File;
		const arrayBuffer = await picFile.arrayBuffer();
		const buffer = Buffer.from(arrayBuffer);

		cloudinary.uploader
			.upload_stream({ resource_type: 'auto' }, (err, res) => {
				if (err) {
					console.error(err);
					return;
				}

				const imageURL = res?.secure_url;
				if (imageURL) {
					formData.append('image_url', imageURL);
					createUser(formData);
				}
			})
			.end(buffer);
	}
} satisfies Actions;

const createUser = (formData: FormData) => {
	formData.delete('profile-picture');
	fetch('http://127.0.0.1:4000/api/users', {
		method: 'POST',
		body: formData
	}).catch((e) => {
		console.error(e);
	});
};
