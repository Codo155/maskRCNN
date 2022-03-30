
function boxLabelImage=getBoxLabel(img, xCoordinate, yCoordinate, boxHeight,boxWidth)
    img(:,:) = 0;
     % left vertical line
    img(xCoordinate,(yCoordinate:yCoordinate + boxWidth))=1;

    % right vertical line
    img(xCoordinate+boxHeight,(yCoordinate:yCoordinate + boxWidth))=1;

    % lower horizontal line
    img((xCoordinate:xCoordinate + boxHeight),yCoordinate)=1;
    
    % 
    img((xCoordinate:xCoordinate + boxHeight),yCoordinate+boxWidth)=1;
    boxLabelImage=img;
end