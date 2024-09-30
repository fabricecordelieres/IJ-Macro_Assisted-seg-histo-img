ori=getTitle();
close("\\Others");
roiManager("Reset");

//Eliminer les annotations
makeRectangle(0, 0, 189, 25);
setForegroundColor(255, 255, 255);
run("Fill", "slice");
makeRectangle(2829, 2003, 243, 45);
run("Fill", "slice");
run("Select None");

//evaluateur de fond
run("Duplicate...", "title=Fond");
run("Gaussian Blur...", "sigma=150");

//Correction illumination
selectImage(ori);
run("RGB Stack");
selectImage("Fond");
run("RGB Stack");

imageCalculator("Divide create 32-bit stack", ori,"Fond");
rename(ori+"_IllumCorr");
setOption("ScaleConversions", true);
run("8-bit");
run("RGB Color");

selectImage(ori);
run("RGB Color");
close("Fond");

selectImage(ori+"_IllumCorr");
run("Subtract Background...", "rolling=50 light");
run("Median...", "radius=5");

run("Color Threshold...");
waitForUser("Décocher Hue/Pass\nAjuster les seuils\nBien sélectionner \"Filtered\"\npuis cliquer sur Ok");

run("Analyze Particles...", "size=1000-Infinity pixel show=Masks summarize add");

selectWindow(ori);
roiManager("Show All without labels");
run("Flatten");


Dialog.create("Valeurs");
Dialog.addNumber("Hue_min", 0);
Dialog.addNumber("Hue_max", 255);
Dialog.addNumber("Sat_min", 0);
Dialog.addNumber("Sat_max", 255);
Dialog.addNumber("Bright_min", 0);
Dialog.addNumber("Bright_max", 255);
Dialog.show();

selectWindow("Summary");
nRows=Table.size-1;
headers=newArray("Hue_min", "Hue_max", "Sat_min", "Sat_max", "Bright_min", "Bright_max");
for(i=0; i<headers.length; i++){
	Table.set(headers[i], nRows, Dialog.getNumber());
}
