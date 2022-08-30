function ret = Ad2d(T)

%     ret = [1, 0, 0; so2(T(1:2,3)), T(1:2, 1:2)];

    ret = [1, 0, 0; [T(2,3); -T(1,3)], T(1:2, 1:2)];

end

