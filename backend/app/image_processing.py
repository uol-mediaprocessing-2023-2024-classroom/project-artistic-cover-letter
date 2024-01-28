import os
import cv2
from PIL import Image
import urllib.request
from ultralytics import YOLO
from ressources.letters import get_iteration

iteration = get_iteration()
img_letter = []
model = YOLO("ressources/yolov8m.pt")

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
            cropImage.save("app/bib/"+str(iteration)+"_"+str(i)+".jpg")
            url = f"http://localhost:8000/static/{str(iteration)}_{str(i)}.jpg"
            cropped_image_urls.append(url)
            i += 1
    else:
        cropImage = Image.open("ressources/placeholder.jpg")
        cropImage.save("app/bib/"+str(iteration)+"_0.jpg")
        url = f"http://localhost:8000/static/{str(iteration)}_0.jpg"
        cropped_image_urls.append(url)
    img_letter.append(str(iteration)+"_0.jpg")
    return cropped_image_urls 

# Downloads an image from the specified URL and saves it to the given path.
def download_image(image_url: str, img_path: str):
    urllib.request.urlretrieve(image_url, img_path)


# Deletes the file at the specified path.
def remove_file(path: str):
    os.unlink(path)

def remove_all(path: str):
    for f in os.listdir(path):
        os.remove(os.path.join(path, f))

