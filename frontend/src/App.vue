<template>
    <v-app>
        <v-main>
            <!-- Communication between child and parent components can be done using props and events. Props are attributes passed from a parent to a child and can be used within it.
            A child component can emit events, which the parent then may react to. Here "selectedImage" is a prop passed to HomePage. HomePage emits the "fetchImgs" event,
            which triggers the fetchImgs method in App.vue. In this demo this is technically not needed, but since it's a core element of Vue I decided to include it.-->
            <HomePage :selectedImage="selectedImage" :currentGallery="currentGallery" @loadImages="loadImages" @loadLetters="loadLetters" @updateSelected="updateSelected" @getBlur="getBlur" @getCrop="getCrop" @resetGallery="resetGallery" />
        </v-main>
    </v-app>
</template>

<script>
import HomePage from "./components/HomePage";
import placeholder from "./assets/placeholder.jpg";

export default {
    name: "App",

    components: {
        HomePage,
    },

    data() {
        return {
            selectedImage: {
                url: placeholder,
                id: "placeholder"
            },
            currentGallery: [],
            allImgData: [],
            limit: 60,
            loadedAmount: 0
        };
    },

    methods: {

        /* 
          This method fetches the first 60 images from a user's gallery. 
          It first retrieves all image IDs, then it fetches specific image data. 
        */
        async loadImages(cldId) {

            const headers = {
                cldId: cldId,
                clientVersion: "0.0.1-medienVerDemo",
            };

            // Fetch all image IDs from the user's gallery
            const response = await fetch("https://cmp.photoprintit.com/api/photos/all?orderDirection=asc&showHidden=false&showShared=false&includeMetadata=false", {
                headers: headers
            });
            this.allImgData = await response.json();

            // Reset current gallery and loaded amount before fetching new images
            this.currentGallery = [];
            this.loadedAmount = 0;

            // Fetch detailed image info for each image up to the limit
            for (const photo of this.allImgData.photos) {
                if (this.loadedAmount >= this.limit) break;
                this.loadedAmount++;

                // Construct URL for specific image info and fetch data
                const url = `https://cmp.photoprintit.com/api/photos/${photo.id}.jpg?size=300&errorImage=false&cldId=${cldId}&clientVersion=0.0.1-medienVerDemo`;
                const imgResponse = await fetch(url);
                const imgUrl = imgResponse.url;

                // Push image data to current gallery
                this.currentGallery.push({
                    id: photo.id,
                    name: photo.name,
                    avgColor: photo.avgHexColor,
                    timestamp: photo.timestamp,
                    type: photo.mimeType,
                    url: imgUrl
                });
            }
        },

        /* 
          This method updates the currently selected image. 
          It fetches the high-resolution URL of the selected image and updates the selectedImage property. 
        */
        async updateSelected(selectedId, cldId) {

            // Construct URL for fetching the high-resolution image
            const url = `https://cmp.photoprintit.com/api/photos/${selectedId}.org?size=original&errorImage=false&cldId=${cldId}&clientVersion=0.0.1-medienVerDemo`;
            const response = await fetch(url);

            // Find the image data in the current gallery
            const image = this.currentGallery.find((obj) => obj.id === selectedId);

            // Update the selected image with high-resolution URL and other details
            this.selectedImage = {
                url: response.url,
                id: selectedId,
                name: image.name,
                avgColor: image.avgColor,
            };
        },

        /* This method retrieves a blurred version of the selected image from the backend. */
        async getBlur(selectedId, cldId) {

            const localUrl = `http://127.0.0.1:8000/get-blur/${cldId}/${selectedId}`;

            // Fetch the blurred image
            const response = await fetch(localUrl);
            const imageBlob = await response.blob();
            const blurImgUrl = URL.createObjectURL(imageBlob);

            // Update the selected image with the URL of the blurred image
            this.selectedImage.url = blurImgUrl;
        },

        /* This method retrieves a cropped version of the selected image from the backend. */
        async getCrop(selectedId, cldId) {

            const localUrl = `http://127.0.0.1:8000/get-crop/${cldId}/${selectedId}`;

            // Fetch the cropped image
            const response = await fetch(localUrl);
            const imageBlob = await response.blob();
            const cropImgUrl = URL.createObjectURL(imageBlob);

            // Update the selected image with the URL of the cropped image
            this.selectedImage.url = cropImgUrl;
        },

        /* This method retrieves a cropped version of the selected image from the backend. */
        async loadLetters(yourname) {

        },

        /* This method resets the current gallery and selected image. */
        resetGallery() {

            this.selectedImage = {
                url: placeholder,
                id: "placeholder"
            };
            this.currentGallery = [];
        },
    },
};
</script>
