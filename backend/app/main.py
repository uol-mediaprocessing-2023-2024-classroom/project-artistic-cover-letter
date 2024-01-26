import os
import glob
import ssl
import urllib.request
import cv2
import matplotlib.pyplot as plt
import numpy as np
import random

from fastapi import FastAPI, BackgroundTasks, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse
from PIL import Image
from ultralytics import YOLO

iteration = 0
img_letter = []
app = FastAPI()

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

lettres = {
    'A': [
        "01100",
        "10010",
        "11110",
        "10010",
        "10010"
    ],
    'B': [
        "11100",
        "10010",
        "11100",
        "10010",
        "11100"
    ],
    'C': [
        "01110",
        "10000",
        "10000",
        "10000",
        "01110"

    ],
    'D': [
        "11100",
        "10010",
        "10010",
        "10010",
        "11100"
    ],
    'E': [
        "11110",
        "10000",
        "11100",
        "10000",
        "11110"
    ],
    'F': [
        "11110",
        "10000",
        "11100",
        "10000",
        "10000"
    ],
    'G': [
        "01100",
        "10000",
        "10110",
        "10010",
        "01100"
    ],
    'H': [
        "10010",
        "10010",
        "11110",
        "10010",
        "10010"
    ],
    'I': [
        "1110",
        "0100",
        "0100",
        "0100",
        "1110"
    ],
    'J': [
        "00010",
        "00010",
        "00010",
        "10010",
        "01100"
    ],
    'K': [
        "10010",
        "10100",
        "11000",
        "10100",
        "10010"
    ],
    'L': [
        "10000",
        "10000",
        "10000",
        "10000",
        "11110"
    ],
    'M': [
        "100010",
        "110110",
        "101010",
        "100010",
        "100010"
    ],
    'N': [
        "10010",
        "11010",
        "10110",
        "10010",
        "10010"
    ],
    'O': [
        "01100",
        "10010",
        "10010",
        "10010",
        "01100"
    ],
    'P': [
        "11100",
        "10010",
        "11100",
        "10000",
        "10000"
    ],
    'Q': [
        "01100",
        "10010",
        "10010",
        "10110",
        "01110"
    ],
    'R': [
        "11100",
        "10010",
        "11100",
        "10100",
        "10010"
    ],
    'S': [
        "01110",
        "10000",
        "01100",
        "00010",
        "11100"
    ],
    'T': [
        "111110",
        "001000",
        "001000",
        "001000",
        "001000"
    ],
    'U': [
        "10010",
        "10010",
        "10010",
        "10010",
        "01100"
    ],
    'V': [
        "100010",
        "100010",
        "010100",
        "010100",
        "001000"
    ],
    'W': [
        "100010",
        "101010",
        "101010",
        "110110",
        "100010"
    ],
    'X': [
        "100010",
        "010100",
        "001000",
        "010100",
        "100010"
    ],
    'Y': [
        "100010",
        "010100",
        "001000",
        "001000",
        "001000"
    ],
    'Z': [
        "11110",
        "00010",
        "00100",
        "01000",
        "11110"
    ]
    # Ajoutez d'autres lettres si nécessaire
} # Letter 

@app.get("/get-crop/{cldId}/{imgId}")
async def get_crop(cldId: str, imgId: str, background_tasks: BackgroundTasks):
    """
    Endpoint to retrieve a cropped version of an image.
    The image is fetched from a constructed URL and then processed to apply a crop effect.
    """
    global iteration
    img_path = f"app/bib/{imgId}.jpg"
    image_url = f"https://cmp.photoprintit.com/api/photos/{imgId}.org?size=original&errorImage=false&cldId={cldId}&clientVersion=0.0.1-medienVerDemo"

    download_image(image_url, img_path)
    apply_crop(img_path)

    # Schedule the image file to be deleted after the response is sent
    background_tasks.add_task(remove_file, img_path)
    # Send the cropped image file as a response
    img_path = f"app/bib/"+str(iteration)+"_0.jpg"
    iteration += 1
    return FileResponse(img_path)

@app.get("/get-letter/{yourname}")
async def get_letter(yourname: str, background_tasks: BackgroundTasks):

    img_path = f"app/collage/done.jpg"
    
    apply_letter(yourname, img_path)
    
    # Schedule the image file to be deleted after the response is sent
    background_tasks.add_task(remove_all, "app/bib")
    # Send the cropped image file as a response
    return FileResponse(img_path)

@app.get("/get-del/{index}")
async def get_del(index: str):

    for filename in glob.glob("app/bib/"+index+"*"):
        os.remove(filename)   

@app.get("/delete")
async def delete():

    global img_letter
    path= "app/bib"
    for f in os.listdir(path):
        os.remove(os.path.join(path, f))
    img_letter = []
    
@app.get("/edit/{img}")
async def edit(img :str):
    global img_letter
    
    (i, nb)  = img.split("_")
    img_letter[i] = i+"_"+nb

    return FileResponse("app/bib/"+img_letter[i])


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
            cropImage.save("app/bib/"+str(iteration)+"_"+str(i)+".jpg")
        
            i += 1
        cropImage = Image.open(img) #Load PIL Image
        box = (centre[0][0]-square, centre[0][1], centre[0][0]+square, centre[0][1]+2*square)

        cropImage = cropImage.crop(box)
        cropImage.save(img_path)
    else:
        cropImage = Image.open("ressources/placeholder.jpg")
        cropImage.save("app/bib/"+str(iteration)+"_0.jpg")
        cropImage.save(img_path)
    img_letter.append(str(iteration)+"_0.jpg")    
    #iteration += 1

# letter.
def apply_letter(yourname: str, img_path: str):
    liste_images = []
    image_used =[]
    global img_letter

    def afficher_lettre_en_pixels_avec_quadrillage(lettre, position_x, position_y, taille=150):
        # Créer un tableau avec les valeurs de la lettre
        tableau_lettre = np.array([[int(pixel) for pixel in ligne] for ligne in lettre])

        # Créer une image en utilisant imshow
        for i in range(tableau_lettre.shape[0]):
            for j in range(tableau_lettre.shape[1]):
                if tableau_lettre[i, j] == 1:

                    if liste_images:
                    # Générer un indice aléatoire
                        indice_aleatoire = random.randint(0, len(liste_images) - 1)

                        #image_path = '/content/image.jpg'
                        image = Image.open("app/bib/"+liste_images[indice_aleatoire])
                        image = image.resize((taille, taille))
                        image_tourne = image.transpose(Image.FLIP_TOP_BOTTOM)

                        # Placer l'image dans la case noire
                        ax.imshow(image_tourne, extent=(position_x + j*taille, position_x + (j+1)*taille, position_y + i*taille, position_y + (i+1)*taille), cmap='binary', vmin=0, vmax=1)
                        image_used.append(liste_images[indice_aleatoire])
                        liste_images.remove(liste_images[indice_aleatoire])

                    else: 
                        indice_aleatoire = random.randint(0, len(image_used) - 1)

                        #image_path = '/content/image.jpg'
                        image = Image.open("app/bib/"+image_used[indice_aleatoire])
                        image = image.resize((taille, taille))
                        image_tourne = image.transpose(Image.FLIP_TOP_BOTTOM)

                        # Placer l'image dans la case noire
                        ax.imshow(image_tourne, extent=(position_x + j*taille, position_x + (j+1)*taille, position_y + i*taille, position_y + (i+1)*taille), cmap='binary', vmin=0, vmax=1)                  
                
        # Ajouter des lignes de quadrillage
        ax.set_xticks(np.arange( -0.5, position_x + len(lettre[0]) * taille - 0.5, taille), minor=True)
        ax.set_yticks(np.arange(- 0.5, position_y + len(lettre) * taille - 0.5, taille), minor=True)
        ax.invert_yaxis()
        ax.axis('off')
        plt.draw()

    mot = yourname
    position_x = 0
    position_y = 0

    # Créer une figure et un axe une seule fois pour afficher toutes les lettres du mot
    fig, ax = plt.subplots()
    liste_images = img_letter
    # Parcourt chaque lettre dans le mot et affiche chaque lettre sous forme de pixels
    for lettre in mot.upper():  # Convertit toutes les lettres en majuscules
        print(lettre)
        if lettre in lettres:
            afficher_lettre_en_pixels_avec_quadrillage(lettres[lettre], position_x, position_y)
            position_x += len(lettres[lettre][0]) * 150 + 200  # Ajuster la position pour la lettre suivante
        else:
            print("Lettre non prise en charge:", lettre)

    plt.savefig(img_path) 
    global iteration
    iteration = 0

# Deletes the file at the specified path.
def remove_file(path: str):
    os.unlink(path)

def remove_all(path: str):
    for f in os.listdir(path):
        os.remove(os.path.join(path, f))

def delete(path= "app/bib"):
    for f in os.listdir(path):
        os.remove(os.path.join(path, f))

# Global exception handler that catches all exceptions not handled by specific exception handlers.
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    # Print the exception type and its message for debugging
    print(f"Exception type: {type(exc).__name__}")
    print(f"Exception message: {str(exc)}")

    return JSONResponse(
        status_code=500,
        content={"message": "An unexpected error occurred."},
    )
