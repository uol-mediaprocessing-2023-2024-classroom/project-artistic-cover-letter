import os
import ssl
import urllib.request
import cv2
import matplotlib.pyplot as plt
import numpy as np
import random
from fastapi import FastAPI, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from PIL import Image
from ultralytics import YOLO
from fastapi.staticfiles import StaticFiles
from ressources.letters import Letters

iteration = 0
img_letter = []
app = FastAPI()
app.mount("/static", StaticFiles(directory="temp_images"), name="static")
app.mount("/static", StaticFiles(directory="collage"), name="static")
# SSL configuration for HTTPS requests
ssl._create_default_https_context = ssl._create_unverified_context

# CORS configuration: specify the origins that are allowed to make cross-site requests
origins = [
    "https://localhost:8080",
    "https://localhost:8080/",
    "http://localhost:8080",
    "http://localhost:8080/",
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# A simple endpoint to verify that the API is online.
@app.get("/")
def home():
    return {"Test": "Online"}

model = YOLO("ressources/yolov8m.pt")

@app.get("/get-crop/{cldId}/{imgId}")
async def get_crop(cldId: str, imgId: str, background_tasks: BackgroundTasks):
    """
    Endpoint to retrieve a cropped version of an image.
    The image is fetched from a constructed URL and then processed to apply a crop effect.
    """
    global iteration
    
    img_path = f"temp_images/{imgId}.jpg"
    image_url = f"https://cmp.photoprintit.com/api/photos/{imgId}.org?size=original&errorImage=false&cldId={cldId}&clientVersion=0.0.1-medienVerDemo"

    download_image(image_url, img_path)
    response = apply_crop(img_path)

    # Schedule the image file to be deleted after the response is sent
    background_tasks.add_task(remove_file, img_path)
    # Send the cropped image file as a response
    # img_path = f"app/bib/"+str(iteration)+"_0.jpg"
    iteration += 1
    return response

#create collage from the cropped images name and collage name
@app.get("/create-collage/{collage_name}/{img_names}")
async def get_letter(collage_name: str,img_names: str, background_tasks: BackgroundTasks):

    img_path = f"collage/collage.jpg"
    
    #apply_letter(yourname, img_path)
    create_collage(collage_name, img_names)
    # Schedule the image file to be deleted after the response is sent
    background_tasks.add_task(remove_all, "temp_images")
    # Send the cropped image file as a response
    return FileResponse(img_path)


# Downloads an image from the specified URL and saves it to the given path.
def download_image(image_url: str, img_path: str):
    urllib.request.urlretrieve(image_url, img_path)

# Opens the image from the given path and applies a crop effect.
def apply_crop(img_path: str):
    img = (img_path)
    global iteration
    global img_letter

    # get the middle of the image
    data = []# y, x of center 
    save = cv2.imread(img)
    (h, w) = save.shape[:2]
    data.append([round(h/2), round(w/2)])

    results = model(img) # YOLO result for the image

    centre = [] # list of different centre of yolo box
    cropped_image_urls = [] # list of different images
    pointer = 0 # will change later

    for result in results:
        for boxe in result.boxes.conf:
            if boxe.numpy() > 0.7 : # if % > 0.7
                test = result.boxes.xyxy.numpy()
                centre.append([round((test[pointer][2]+test[pointer][0])/2), round(test[pointer][1])])
            
                pointer += 1
   
    square = 150 #Lenght of the square

    i = 0
    print(centre)   
    if centre != []:
        for cen in centre:
            if (cen[0]-square) < 0:
                cen[0] = cen[0] + -1*(cen[0]-square)
            if (cen[0]+square) > w:
                cen[0] = cen[0] - -1*(w-(cen[0]+square))
            if cen[1]+2*square > h:
                cen[1] = cen[1] + 1*(h-(cen[1]+2*square))
            cropImage = Image.open(img)
            box = (cen[0]-square, cen[1], cen[0]+square, cen[1]+2*square)
            cropImage = cropImage.crop(box)
            cropImage.save("temp_images/"+str(iteration)+"_"+str(i)+".jpg")
            url = f"http://localhost:8000/static/{str(iteration)}_{str(i)}.jpg"
            cropped_image_urls.append(url)
            i += 1
    else:
        cropImage = Image.open("ressources/placeholder.jpg")
        cropImage.save("temp_images/"+str(iteration)+"_0.jpg")
        url = f"http://localhost:8000/static/{str(iteration)}_0.jpg"
        cropped_image_urls.append(url)
    img_letter.append(str(iteration)+"_0.jpg")
    return cropped_image_urls 


# Creates a collage from the given images name and collage name.
def create_collage(collage_name: str, img_names: str):
    img_path = f"collage/collage.jpg"
    liste_images = img_names.split('-')
    image_used = []

    word = collage_name.upper()
    taille = 70  # Taille de chaque image
    espacement = 10  # Espacement entre les lettres

     # Calculer la largeur totale nécessaire pour le collage
    largeur_totale = sum([len(Letters[lettre][0]) * taille + espacement for lettre in word if lettre in Letters])

    # Hauteur uniforme pour les lettres
    hauteur_lettre = len(Letters[word[0]]) * (taille + 30) if word else 0  # Utilisez la hauteur de la première lettre comme référence

    fig, ax = plt.subplots(figsize=(largeur_totale / 100, hauteur_lettre / 100))  # Ajuster la hauteur ici

    def afficher_lettre_en_pixels_avec_quadrillage(lettre, position_x, position_y):
        nonlocal liste_images, image_used, ax

        tableau_lettre = np.array([[int(pixel) for pixel in ligne] for ligne in lettre])

        for i in range(tableau_lettre.shape[0]):
            for j in range(tableau_lettre.shape[1]):
                if tableau_lettre[i, j] == 1:
                    if liste_images:
                        indice_aleatoire = random.randint(0, len(liste_images) - 1)
                        image = Image.open("temp_images/" + liste_images[indice_aleatoire] + ".jpg")
                        image = image.resize((taille, taille))
                        image_tourne = image.transpose(Image.FLIP_TOP_BOTTOM)

                        ax.imshow(image_tourne, extent=(position_x + j * taille, position_x + (j + 1) * taille, position_y + i * taille, position_y + (i + 1) * taille))
                        image_used.append(liste_images[indice_aleatoire])
                        liste_images.pop(indice_aleatoire)
                    else:
                        indice_aleatoire = random.randint(0, len(image_used) - 1)
                        image = Image.open("temp_images/" + image_used[indice_aleatoire] + ".jpg")
                        image = image.resize((taille, taille))
                        image_tourne = image.transpose(Image.ADAPTIVE)

                        ax.imshow(image_tourne, extent=(position_x + j * taille, position_x + (j + 1) * taille, position_y + i * taille, position_y + (i + 1) * taille))

        ax.set_xticks(np.arange(-0.5, position_x + len(lettre[0]) * taille - 0.5, taille), minor=True)
        ax.set_yticks(np.arange(-0.5, position_y + len(lettre) * taille - 0.5, taille), minor=True)
        ax.invert_yaxis()
        ax.axis('off')
        plt.draw()

    position_x = 0
    position_y = 0

    for lettre in word:
        if lettre in Letters:
            afficher_lettre_en_pixels_avec_quadrillage(Letters[lettre], position_x, position_y)
            position_x += len(Letters[lettre][0]) * taille + espacement
        else:
            print("Letter not supported:", lettre)

    plt.savefig(img_path, dpi=300)
    return FileResponse(img_path)

# Deletes the file at the specified path.
def remove_file(path: str):
    os.unlink(path)

def remove_all(path: str):
    for f in os.listdir(path):
        os.remove(os.path.join(path, f))



