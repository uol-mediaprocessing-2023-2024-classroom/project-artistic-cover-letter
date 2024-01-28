import numpy as np
import random
import matplotlib.pyplot as plt
from PIL import Image
from ressources.letters import Letters
from fastapi.responses import FileResponse

# Creates a collage from the given images name and collage name.
def create_collage(collage_name: str, img_names: str):

    img_path = f"app/collage/collage.jpg"
    liste_images = img_names.split('-')
    image_used = []

    def afficher_lettre_en_pixels_avec_quadrillage(lettre, position_x, position_y, taille=150):
        nonlocal liste_images, image_used, ax

        tableau_lettre = np.array([[int(pixel) for pixel in ligne] for ligne in lettre])

        for i in range(tableau_lettre.shape[0]):
            for j in range(tableau_lettre.shape[1]):
                if tableau_lettre[i, j] == 1:
                    if liste_images:
                        indice_aleatoire = random.randint(0, len(liste_images) - 1)
                        image = Image.open("app/bib/" + liste_images[indice_aleatoire]+".jpg")
                        image = image.resize((taille, taille))
                        image_tourne = image.transpose(Image.FLIP_TOP_BOTTOM)

                        ax.imshow(image_tourne, extent=(position_x + j*taille, position_x + (j+1)*taille, position_y + i*taille, position_y + (i+1)*taille))
                        image_used.append(liste_images[indice_aleatoire])
                        liste_images.pop(indice_aleatoire)
                    else:
                        indice_aleatoire = random.randint(0, len(image_used) - 1)
                        image = Image.open("app/bib/" + image_used[indice_aleatoire]+".jpg")
                        image = image.resize((taille, taille))
                        image_tourne = image.transpose(Image.FLIP_TOP_BOTTOM)

                        ax.imshow(image_tourne, extent=(position_x + j*taille, position_x + (j+1)*taille, position_y + i*taille, position_y + (i+1)*taille))

        ax.set_xticks(np.arange(-0.5, position_x + len(lettre[0]) * taille - 0.5, taille), minor=True)
        ax.set_yticks(np.arange(-0.5, position_y + len(lettre) * taille - 0.5, taille), minor=True)
        ax.invert_yaxis()
        ax.axis('off')
        plt.draw()

    word = collage_name.upper()
    position_x = 0
    position_y = 0

    fig, ax = plt.subplots()

    for lettre in word:
        if lettre in Letters:
            afficher_lettre_en_pixels_avec_quadrillage(Letters[lettre], position_x, position_y)
            position_x += len(Letters[lettre][0]) * 150 + 200
        else:
            print("Letter not supported:", lettre)

    plt.savefig(img_path)
    return FileResponse(img_path)
