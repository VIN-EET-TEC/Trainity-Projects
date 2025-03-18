use ig_clone;

# Task 1 Loyal User Reward: Identify the five oldest users on Instagram from the provided database.

SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;

# Task2 Inactive User Engagement: Identify users who have never posted a single photo on Instagram.

SELECT 
    *
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.image_url IS NULL;
    
# Task 3 Contest Winner Declaration: Determine the winner of the contest and provide their details to the team.

SELECT 
    u.username,
    p.id,
    p.image_url,
    COUNT(l.user_id) AS 'Total Likes'
FROM
    likes l
        INNER JOIN
    photos p ON p.id = l.photo_id
        INNER JOIN
    users u ON p.user_id = u.id
GROUP BY p.id
ORDER BY COUNT(l.user_id) DESC
LIMIT 4;

# Task 4 Hashtag Research: Identify and suggest the top five most commonly used hashtags on the platform.

SELECT 
    t.tag_name, COUNT(pt.photo_id) AS Total_tags
FROM
    photo_tags pt
        INNER JOIN
    tags t ON pt.tag_id = t.id
GROUP BY t.tag_name
ORDER BY Total_tags DESC
LIMIT 5;

# Task 5 Ad Campaign Launch: Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.

SELECT 
    DAYNAME(created_at) AS Day,
    COUNT(username) AS total_registration
FROM
    users
GROUP BY day
ORDER BY total_registration DESC;

# Task 6 User Engagement: Calculate the average number of posts per user on Instagram. 
# Also, provide the total number of photos on Instagram divided by the total number of users.

SELECT 
    AVG(p.id) AS avg_number_of_posts
FROM
    photos p;

SELECT 
    AVG(u.id) AS avg_number_of_users
FROM
    users u;

SELECT 
    ROUND((SELECT 
                    AVG(p.id) AS avg_number_of_posts
                FROM
                    photos p) / (SELECT 
                    AVG(u.id) AS avg_number_of_users
                FROM
                    users u),
            1) AS avg_number_of_posts_per_user;

SELECT 
    SUM(p.id) AS total_number_of_posts
FROM
    photos p;

SELECT 
    SUM(u.id) AS total_number_of_users
FROM
    users u;

SELECT 
    ROUND((SELECT 
                    SUM(p.id) AS total_number_of_posts
                FROM
                    photos p) / (SELECT 
                    SUM(u.id) AS total_number_of_users
                FROM
                    users u),
            1) AS total_number_of_posts_per_user;
            
# Task 7 Bots & Fake Accounts: Identify users (potential bots) who have liked every single photo on the site, 
# as this is not typically possible for a normal user.

SELECT 
    u.id, u.username, COUNT(u.username) AS Total_likes
FROM
    users u
        JOIN
    likes l ON l.user_id = u.id
GROUP BY u.id
HAVING Total_likes = (SELECT 
        COUNT(*)
    FROM
        photos p);
        