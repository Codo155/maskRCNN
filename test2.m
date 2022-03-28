m = [   0, 0, 0,1,1,1,2 ;
    0,0,1,1,1,1,2;
    0,1,1,1,1,1,0;
    0,0,0,1,1,0,0;
    1,1,0,1,1,1,0] % Last row has 2 contiguous regions instead of 1.
mb = m == 1
[rows, columns] = size(mb);
for row = 1 : rows
    % Make measurements of all lines of 1's.
    props = regionprops(mb(row, :), 'Area');
    % Extract all the lengths into a vector and then put into a cell.
    R{row} = [props.Area];
end


out = cellfun(@sum,R);