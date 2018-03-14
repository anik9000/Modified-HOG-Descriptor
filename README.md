# Modified-HOG-Descriptor
Text and Non text portions present in a document image are recognized using modified HOG Descriptor
Following is the link of the paper of my work.
https://www.researchgate.net/publication/323000479_Text_and_non-text_recognition_using_modified_HOG_descriptor

I suggest you to read this paper first before downloading the codes for better understanding of the concepts. 
Basically, there are two functions "HOGModified" and "minimalBoundaryReturnGrayImage" where HOGModified function 
would generate features for each image provided as input. The other function is called by the HOGModified function. 
HOGFeatures is the matlab code which is calling HOGModified function each time for generating the features of every image. 
HOGFeatures would take that folder as input where all the text and non text components are preserved by you. 
Finally, it would create a csv file containing all the features of all the images provided.
