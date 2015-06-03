% this is the compare step.
function fog_degree = compare(Im, v_pointHeight, h_lineHeight)
% it analyzes the fog intensity by comparing the vanishing point
% with the horizontal line (get by segmentation).

differ = abs(v_pointHeight - h_lineHeight);
fog_degree = differ / size(Im, 1);
fog_degree = fog_degree * 10;

end
